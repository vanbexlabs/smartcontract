contract SimpleStorage {
    uint storedData;
    function set(uint x) {
        storedData = x;
    }
    function get() constant returns (uint retVal) {
        return storedData;
    }
}
contract Coin {
    address minter;
    mapping (address => uint) balances;
    function Coin() {
        minter = msg.sender;
    }
    function mint(address owner, uint amount) {
        if (msg.sender != minter) return;
        balances[owner] += amount;
    }
    function send(address receiver, uint amount) {
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
    }
    function queryBalance(address addr) constant returns (uint balance) {
        return balances[addr];
    }
}
contract Ballot {
    function Ballot(uint8 _numProposals) {
        address sender = msg.sender;
        chairperson = sender;
        numProposals = _numProposals;
    }

    function giveRightToVote(address voter) {
        if (msg.sender != chairperson || voted[voter]) return;
        voterWeight[voter] = 1;
    }

    function delegate(address to) {
        address sender = msg.sender;
        if (voted[sender]) return;
        while (delegations[to] != address(0) && delegations[to] != sender)
            to = delegations[to];
        if (to == sender) return;
        voted[sender] = true;
        delegations[sender] = to;
        if (voted[to]) voteCounts[votes[to]] += voterWeight[sender];
        else voterWeight[to] += voterWeight[sender];
    }

    function vote(uint8 proposal) {
        address sender = msg.sender;
        if (voted[sender] || proposal >= numProposals) return;
        voted[sender] = true;
        votes[sender] = proposal;
        voteCounts[proposal] += voterWeight[sender];
    }

    function winningProposal() constant returns (uint8 winningProposal) {
        uint256 winningVoteCount = 0;
        uint8 proposal = 0;
        while (proposal < numProposals) {
            if (voteCounts[proposal] > winningVoteCount) {
                winningVoteCount = voteCounts[proposal];
                winningProposal = proposal;
            }
            ++proposal;
        }
    }

    address chairperson;
    uint8 numProposals;
    mapping(address => uint256) voterWeight;
    mapping(address => bool) voted;
    mapping(address => uint8) votes;
    mapping(address => address) delegations;
    mapping(uint8 => uint256) voteCounts;
}

