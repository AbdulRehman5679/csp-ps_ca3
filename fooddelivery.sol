// SPDX-License-Identifier: MIT
// FoodDeliveryContract.sol
pragma solidity ^0.7.5;

contract FoodDeliveryContract {
    enum OrderStatus { Placed, InProgress, Delivered, Completed }

    struct Order {
        address customer;
        string restaurant;
        string deliveryAddress;
        uint256 timestamp;
        OrderStatus status;
    }

    mapping(uint256 => Order) public orders;
    uint256 public orderCount;

    event OrderPlaced(uint256 orderId, address customer, string restaurant, string deliveryAddress, uint256 timestamp);
    event OrderInProgress(uint256 orderId, uint256 timestamp);
    event OrderDelivered(uint256 orderId, uint256 timestamp);
    event OrderCompleted(uint256 orderId, uint256 timestamp);

    function placeOrder(string memory _restaurant, string memory _deliveryAddress) external {
        orderCount++;
        Order storage newOrder = orders[orderCount];
        newOrder.customer = msg.sender;
        newOrder.restaurant = _restaurant;
        newOrder.deliveryAddress = _deliveryAddress;
        newOrder.timestamp = block.timestamp;
        newOrder.status = OrderStatus.Placed;

        emit OrderPlaced(orderCount, msg.sender, _restaurant, _deliveryAddress, block.timestamp);
    }

    function markOrderInProgress(uint256 _orderId) external {
    require(_orderId > 0 && _orderId <= orderCount, "Invalid order ID");
    Order storage order = orders[_orderId];
    require(order.customer == msg.sender, "Unauthorized");
    require(order.status == OrderStatus.Placed, "Order is not in progress");

    order.status = OrderStatus.InProgress;

    emit OrderInProgress(_orderId, block.timestamp);
    }

    function markOrderDelivered(uint256 _orderId) external {
        require(_orderId > 0 && _orderId <= orderCount, "Invalid order ID");
        Order storage order = orders[_orderId];
        require(order.customer == msg.sender, "Unauthorized");
        require(order.status == OrderStatus.InProgress, "Order is not in progress");

        order.status = OrderStatus.Delivered;

        emit OrderDelivered(_orderId, block.timestamp);
    }

    function markOrderCompleted(uint256 _orderId) external {
        require(_orderId > 0 && _orderId <= orderCount, "Invalid order ID");
        Order storage order = orders[_orderId];
        require(order.customer == msg.sender, "Unauthorized");
        require(order.status == OrderStatus.Delivered, "Order is not delivered");

        order.status = OrderStatus.Completed;

        emit OrderCompleted(_orderId, block.timestamp);
    }
}
