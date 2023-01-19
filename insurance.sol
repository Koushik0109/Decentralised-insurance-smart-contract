pragma solidity ^0.8.0;

contract Insurance {
    mapping(address => uint256) public policyIds;
    mapping(uint256 => address) public policyOwners;
    mapping(uint256 => uint256) public policyAmounts;
    mapping(uint256 => uint256) public policyExpDates;
    mapping(uint256 => bool) public policyClaims;
    address public insurer;
    event PolicyCreated(uint256 policyId, address policyOwner, uint256 policyAmount, uint256 policyExpDate);
    event PolicyClaimed(uint256 policyId, address policyOwner);

    constructor(address _insurer) public {
        insurer = _insurer;
    }

    function createPolicy(uint256 policyAmount, uint256 policyExpDate) public payable {
        require(msg.value == policyAmount);
        require(now <= policyExpDate);
        uint256 policyId = policyIds[msg.sender].add(1);
        policyIds[msg.sender] = policyId;
        policyOwners[policyId] = msg.sender;
        policyAmounts[policyId] = policyAmount;
        policyExpDates[policyId] = policyExpDate;
        emit PolicyCreated(policyId, msg.sender, policyAmount, policyExpDate);
    }

    function claimPolicy(uint256 policyId) public {
        require(policyOwners[policyId] == msg.sender);
        require(!policyClaims[policyId]);
        require(now >= policyExpDates[policyId]);
        policyClaims[policyId] = true;
        msg.sender.transfer(policyAmounts[policyId]);
        emit PolicyClaimed(policyId, msg.sender);
    }
}
