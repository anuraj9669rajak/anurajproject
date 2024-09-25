module MyModule::PublicOpinionPolls {

    use aptos_framework::signer;
    use std::vector;

    /// Struct representing a poll.
    struct Poll has store, key {
        question: vector<u8>,       // The poll question
        options: vector<u64>,       // List of vote counts for each option
        voters: vector<address>,    // Addresses of users who voted
    }

    /// Function to create a new poll with multiple options.
    public fun create_poll(owner: &signer, question: vector<u8>, num_options: u64) {
        let options = vector::empty<u64>();
        let i = 0;
        while (i < num_options) {
            vector::push_back(&mut options, 0);  // Initialize vote count to 0 for each option
            i = i + 1;
        };
        let poll = Poll {
            question,
            options,
            voters: vector::empty<address>(),
        };
        move_to(owner, poll);
    }

    /// Function to vote on a poll.
    public fun vote(poll_owner: address, voter: &signer, option: u64) acquires Poll {
        let poll = borrow_global_mut<Poll>(poll_owner);
        
        // Check if voter has already voted
        let voter_address = signer::address_of(voter);
        let n = vector::length(&poll.voters);
        let i = 0;
        while (i < n) {
            assert!(vector::borrow(&poll.voters, i) != &voter_address, 1);  // Ensure no duplicate voting
            i = i + 1;
        };
        
        // Cast the vote
        // poll.options[option] = poll.options[option] + 1;
        vector::push_back(&mut poll.voters, voter_address);  // Record voter address
    }
}
