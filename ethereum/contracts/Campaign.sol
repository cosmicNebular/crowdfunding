pragma solidity >=0.4.22 <0.7.0;


contract CampaignFactory {

    Campaign[] public deployedCampaigns;

    function createCampaign(uint minimum) public {
        Campaign newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (Campaign[] memory) {
        return deployedCampaigns;
    }
}


contract Campaign {
    // Manager is the one creating the contract
    // MinimumContribution is the min amount needed to create the project
    struct Request {
        string description;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;

    //Modifier is needed to restrict non managers from requesting payment of any sort
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }


    constructor(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        approvers[msg.sender] = true;
        approversCount++;
    }


    function createRequest(string memory description, uint value, address payable recipient) public restricted {
        Request memory newRequest = Request({
        description : description,
        value : value,
        recipient : recipient,
        complete : false,
        approvalCount : 0
        });

        requests.push(newRequest);
    }


    function approveRequest(uint index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!requests[index].approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }


    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function getSummary() public view returns (
        uint, uint, uint, uint, address
    ) {
        return (
        minimumContribution,
        this.balance,
        requests.length,
        approversCount,
        manager
        );
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
}