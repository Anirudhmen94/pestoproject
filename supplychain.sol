// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {

    struct Product {
        string name;
        uint256 quantity;
        bool shipped;
        bool delivered;
        uint256 price;
        uint256 invoiceId;
        bool paid;
        bool refunded;
        uint256 refundAmount;
        uint256 refundDeadline;
    }

    mapping(uint256 => Product) public products;

    uint256 public productCount;
    uint256 public invoiceCount;

    uint256 public refundDeadline = 30 days;

    function addProduct(string memory _name, uint256 _quantity, uint256 _price) public {
        productCount++;
        products[productCount] = Product(_name, _quantity, false, false, _price, 0, false, false, 0, 0);
    }

    function shipProduct(uint256 _productId) public {
        require(products[_productId].shipped == false, "Product has already been shipped");
        require(products[_productId].delivered == false, "Product has already been delivered");
        products[_productId].shipped = true;
        generateInvoice(_productId);
    }

    function deliverProduct(uint256 _productId) public {
        require(products[_productId].shipped == true, "Product has not been shipped yet");
        require(products[_productId].delivered == false, "Product has already been delivered");
        products[_productId].delivered = true;
        processPayment(_productId);
    }

    function generateInvoice(uint256 _productId) private {
        invoiceCount++;
        products[_productId].invoiceId = invoiceCount;
    }

    function processPayment(uint256 _productId) private {
        require(products[_productId].paid == false, "Payment has already been processed");
        products[_productId].paid = true;
    }

    function requestRefund(uint256 _productId) public {
        require(products[_productId].delivered == true, "Product has not been delivered yet");
        require(products[_productId].refunded == false, "Refund has already been processed");
        require(block.timestamp <= products[_productId].refundDeadline, "Refund deadline has passed");

        uint256 refundAmount = calculateRefundAmount(_productId);
        products[_productId].refunded = true;
        products[_productId].refundAmount = refundAmount;
        // refund amount is transferred to the customer's account
        payable(msg.sender).transfer(refundAmount);
    }

    function calculateRefundAmount(uint256 _productId) private view returns (uint256) {
        uint256 elapsedTime = block.timestamp - products[_productId].invoiceId;
        uint256 maxElapsedTime = refundDeadline - products[_productId].invoiceId;
        uint256 refundPercentage = (elapsedTime * 100) / maxElapsedTime;
        return (refundPercentage * products[_productId].price) / 100;
    }

    function setRefundDeadline(uint256 _refundDeadline) public {
        refundDeadline = _refundDeadline;
    }
}
