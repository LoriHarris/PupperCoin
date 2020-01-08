pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts

//Why can't we put the puppercoin.sol inside this one with the other two?
// Directions say RefundablePostDeliveryCrowdsale and RefundableCrowdsale but doesn't say to put RefundableCrowdsale in the contract parameters
// If the params are hardcoded in step 2, why do we need them as constructors in step 1
// message must be a non empty string error - when forced it says rpc error with payload
// Message goes away if I send only 300,000 WEI even one over, and it fails.

contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {
 

    constructor(
        uint rate,
        address payable wallet,
        PupperCoin token,
        uint cap,
        uint openingTime,
        uint closingTime, 
        uint goal
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        
        Crowdsale(rate, wallet, token) 
        MintedCrowdsale()
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
        public {}
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;
    
    constructor(
        string memory name,
        string memory symbol,
        address payable wallet
        // @TODO: Fill in the constructor parameters!
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 1);
        token_address = address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale pup_sale = new PupperCoinSale(1, wallet, token, 30000000000000000000, now, now + 2 minutes, 300000000000000000000);
        token_sale_address = address(pup_sale);
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}