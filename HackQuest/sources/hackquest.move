/*
/// Module: hackquest
module hackquest::hackquest;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module hackquest::hackquest {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    // Error codes
    const EInsufficientFunds: u64 = 1;

    // A simple NFT-like object
    struct GameItem has key, store {
        id: UID,
        name: std::string::String,
        power: u64,
    }

    // Create a new GameItem
    public fun create_item(
        name: std::string::String, 
        power: u64, 
        ctx: &mut TxContext
    ): GameItem {
        GameItem {
            id: object::new(ctx),
            name,
            power,
        }
    }

    // Transfer a GameItem to a recipient
    public entry fun transfer_item(
        item: GameItem, 
        recipient: address
    ) {
        transfer::public_transfer(item, recipient);
    }

    // Purchase a GameItem with SUI
    public entry fun purchase_item(
        payment: Coin<SUI>,
        name: std::string::String,
        ctx: &mut TxContext
    ) {
        let value = coin::value(&payment);
        assert!(value >= 1000, EInsufficientFunds);
        
        // Create the item
        let item = create_item(name, value / 100, ctx);
        
        // Transfer the item to the sender
        transfer::public_transfer(item, tx_context::sender(ctx));
        
        // Transfer the payment to the module publisher
        transfer::public_transfer(payment, @hackquest);
    }
}
