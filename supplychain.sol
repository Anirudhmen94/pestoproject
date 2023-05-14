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
    }

    mapping(uint256 => Product) public products;

    uint256 public productCount;
    uint256 public invoiceCount;

    function addProduct(string memory _name, uint256 _quantity, uint256 _price) public {
        productCount++;
        products[productCount] = Product(_name, _quantity, false, false, _price, 0, false);
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
}
