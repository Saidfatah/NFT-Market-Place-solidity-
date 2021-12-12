// SPDX-License_Identifier : MIT
pragma solidity ^0.8.10;
import "./IERC721";

contract Market {
    // public anyone can call 
    // private - only this contract 
    // internal - only this contract and derrived contracts 
    // external - only external calls 

    enum ListingStatus={
        Active,
        Sold,
        Cancelled
    }
    struct Listing{
        address seller;
        address token ; 
        uint tokenId ;
        uint price;
        ListingStatus status;

    }
    
    unint private _listingID = 0 ;
    mapping(uint=>Listing) private _listings;

    function listToken(address token,uint tokenId, uint price,address seller) external  {
        // msg.sender is the address of the person making the transaction
        Listing memory listing =Listing(
            msg.sender,
            token,
            tokenId,
            price,
            ListingStatus.Active
        )
        _listingID++;
       _listings[_listingID] = listing
    }
    
    function buyToken(uint listingId) external payable {
        // why we need to use storage here is because if instead use memory 
        // the corresponding value of the lsiting at the index listingId will be 
        // copied to listingTarget instance and whatever changes will apply won't be reflected
        // in the corresponding listing in _listings
        // using storage allows us to have access to the refrence and thus be able to modify the 
        // instance 

        Listing storage listingTarget = _listings[listingId];
        
        // require acts as an if statement we pass the condition in the first argument 
        // and the error message we want to send in the second argument 
        require(listingTarget.seller != msg.sender,"Seller cannot be buyer ");
        require(listingTarget.status == ListingStatus.Active,"listing is not active");
        require(msg.value => listingTarget.price,"insuffecient amount paied");


    }
}