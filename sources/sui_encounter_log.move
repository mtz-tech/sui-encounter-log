//module 0x380c7e74f1b6e18ce0ddf317a28b4c2c42bef4776042c243d91d4b372364b4a7::encounter_log {
module sui_encounter_log::encounter_log {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::vector;

    struct Encounter has key, store {
        id: UID,
        sender: address,
        receiver: address,
        timestamp: u64
    }

    public entry fun log_encounter(receiver: address, timestamp: u64, ctx: &mut TxContext) {
        let encounter = Encounter {
            id: object::new(ctx),
            sender: tx_context::sender(ctx),
            receiver,
            timestamp
        };
        transfer::public_transfer(encounter, tx_context::sender(ctx));
    }

    public entry fun log_encounters(receivers: vector<address>, timestamp: u64, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        let len = vector::length(&receivers);
        let i = 0; // explicitly typed as u64
        while (i < len) {
            let recv = *vector::borrow(&receivers, i);
            let encounter = Encounter {
                id: object::new(ctx),
                sender,
                receiver: recv,
                timestamp
            };
            transfer::public_transfer(encounter, sender);
            i = i + 1;
        };
    }

    public entry fun burn_expired_encounter(enc: Encounter, _ctx: &mut TxContext) {
        let Encounter { id, sender: _, receiver: _, timestamp: _ } = enc;
        object::delete(id);
    }

    public fun get_info(enc: &Encounter): (address, address, u64) {
        (enc.sender, enc.receiver, enc.timestamp)
    }

    public fun hello(): u64 {
        42
    }
}
