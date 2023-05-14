# pestoproject


The contract defines a struct called "Product", which has several properties including a name, quantity, whether it has been shipped or delivered, a price, an invoice ID, and whether payment has been made.

The contract also has a mapping called "products" that maps product IDs (represented as uint256) to instances of the "Product" struct. The contract keeps track of the total number of products added through the "productCount" variable and the total number of invoices generated through the "invoiceCount" variable.

The contract has several functions that can be called by users.

The "addProduct" function is a public function that allows a user to add a new product to the mapping by providing a name, quantity, and price.

The "shipProduct" function is a public function that takes a product ID as an argument and updates the product's "shipped" property to true. If the product has not already been delivered, the function also calls the "generateInvoice" function to create a new invoice.

The "deliverProduct" function is a public function that takes a product ID as an argument and updates the product's "delivered" property to true. If the product has been shipped and payment has not already been processed, the function also calls the "processPayment" function to process the payment.

The "generateInvoice" and "processPayment" functions are private functions that are called by other functions in the contract. "generateInvoice" creates a new invoice for the product by incrementing the "invoiceCount" variable and setting the product's "invoiceId" property. "processPayment" updates the product's "paid" property to true to indicate that payment has been processed.

Overall, this contract defines a basic supply chain where products can be added, shipped, delivered, and paid for.
