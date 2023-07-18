// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract GreenHills is ERC1155, Ownable, Pausable ,ReentrancyGuard{
    using Strings for uint256;
    uint256 public constant service_id = 0;
    struct Land{
        uint256 id;
        address issuer;
        address reciever;
        string country;
        string region;
        string  latlong;
        uint256 deedNo;
        uint256 service;
        uint256 issue_date;
        string metadata;
        
    }

    mapping(uint256=>Land)private lands;
    mapping(string=>bool)private cids;
    mapping(address=>uint256[])private customers;


    constructor() ERC1155("") {}

   

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        
        return
            string.concat(
                super.uri(tokenId),
                lands[tokenId].metadata
            );
    }
    function mintServices(uint256 amount) public onlyOwner nonReentrant whenNotPaused{
        require(amount!=0,"Amount cannot be zero");
        
        _mint(msg.sender,0,amount,"0x");
    }
    
    function mintLand(uint256 _id,string memory _country,string memory _region,string memory _latlong,uint256 _deedNo ,string memory _metadata)
        public
        onlyOwner
        nonReentrant
        whenNotPaused
    {
        require(_id!=0 ,"Invalid Token Id");
        require(lands[_id].id==0,"Land already exists");
        require(lands[_id].deedNo==0,"Invalid deed no" );
        require(_deedNo!=0,"Invalid Deed No");
        require(bytes(_country).length!=0 && bytes(_region).length!=0 && bytes(_latlong).length!=0,"Arguments cannot be empty");
        require(bytes(_metadata).length>44,"Invalid CID");
        require(cids[_metadata]==false,"CID already exists");
        


        Land memory landData=lands[_id];
        landData.id=_id;
        landData.issuer=msg.sender;
        landData.reciever=address(0);
        landData.country=_country;
        landData.region=_region;
        landData.latlong=_latlong;
        landData.deedNo=_deedNo;
        landData.service=1;
        landData.issue_date=0;
        cids[_metadata]=true;
        landData.metadata=_metadata;
        lands[_id]=landData;

        _mint(msg.sender, _id, 1, "0x");
        
    }
    function updateCid(uint256 tokenId, string memory cid)public  onlyOwner
    {
        require(lands[tokenId].id==tokenId,"Invalid token id");
        require(cids[cid]==false,"CID already exists");
        require(lands[tokenId].reciever==address(0),"Land already transferred");
        require(bytes(cid).length>44,"Invalid CID");

        lands[tokenId].metadata=cid;
       


    }
      function transfer(address to,uint256 _land_id,uint256 _issue_date,string memory newCid) public  onlyOwner nonReentrant whenNotPaused 
    {
       
       require(balanceOf(msg.sender,0)>0,"Service tokens not available");
       require(balanceOf(msg.sender,_land_id)>0,"Land not available");
       require(!Address.isContract(to) && to != address(0) && to != msg.sender, "Invalid User address");
       require(lands[_land_id].reciever==address(0),"Land already Issued/Sold");
       require(lands[_land_id].issue_date==0,"Land already issued");
       require(_issue_date!=0,"Invalid Issue Date");
       require(_land_id!=0,"Invalid Land Id");
       
       uint256 len=customers[to].length;
       if(len>0)
       {
       for(uint256 i=0;i<len;i++)
       {
           require(customers[to][i]!=_land_id,"Land already acquired");

       }
       }
       updateCid(_land_id,newCid);
       lands[_land_id].reciever=to;
       lands[_land_id].issue_date=_issue_date;
       lands[_land_id].service=2;
       
       safeTransferFrom(msg.sender, to,0, 1,"0x");
       safeTransferFrom(msg.sender, to,_land_id, 1,"0x");
       customers[to].push(_land_id);
       
    
      
    }

    function expireService(address user,uint256 land_id,bool state)public onlyOwner{
        require(lands[land_id].id==land_id,"Invalid Land Id");
        require(balanceOf(user,land_id)==1,"Customer doesnot acquire the land");
        require(!Address.isContract(user) && user != address(0) , "Invalid User address");
        
        
        if(state==true)//expire
        {
            require(lands[land_id].service==2 && lands[land_id].service!=3  ,"Service already expired");
            lands[land_id].service=3;  
        }
        else if(state==false)//renew
        {
            require(lands[land_id].service==3 && lands[land_id].service!=2,"Service already active");
             lands[land_id].service=2;
        }
       
    }

    function viewToken(uint256 tokenId) public view returns(Land memory){
        require(lands[tokenId].id==tokenId,"Land doesnot exist");
        return(lands[tokenId]);
    }
    

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}