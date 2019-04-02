pragma solidity 0.4.25;
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  ...
}
// Certainly Correct Receiver Factory Contract
contract CCRFactory is Ownable {
    address _receiver;
    bool _receiveValidation;
event Deposit(address _sender, uint value);
    event Validate(address _receiver);
constructor() {
        _receiveValidation = false;
    }
// only owner can set the address of the receiver
    function setReceiver(address receiver) public onlyOwner {
        _receiver = receiver;
    }
    
    // receiver will confirm that they are the person that we want to interact with
    function confirm() public {
        // verify that the receiver is the correct person (address)
        require(msg.sender == _receiver);
        _receiveValidation = true;
    }
    
    // sender will be able to see if the confirmation has come in from the receiver
    function getConfirmation() public onlyOwner returns(bool) {
        return _receiveValidation;
    }
    
    // the sender will send the funds to the receiver after checks have been made
    function sendToReceiver() onlyOwner public {
        require(_receiveValidation == true);
        release(_receiver);
    }
// internal function to send the contract funds to the receiver address
    function release(address _receiver) internal returns(bool) {
        // transfer ETH to _receiver
        _receiver.send(this.balance);
    }
// manual kill switch for owner to reclaim funds at any time
    function kill() public onlyOwner{
        selfdestruct(msg.sender);
    }
function() payable {
        if (msg.value > 0) {
            Deposit(msg.sender, msg.value);
        }
    }
}
