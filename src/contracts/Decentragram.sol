pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";

  // Store the Images(only the hashes rest will be stored in other server)
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // Create Images

  function uploadImage(string memory _imgHash, string memory _description) public {
    require(bytes(_imgHash).length > 0);
    require(bytes(_description).length > 0);
    
    require(msg.sender != address(0));
    imageCount++;

    // Creating the Image
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);

    // Trigger an event
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  // Tip Images
  function tipImageOwner(uint _id) public payable {

    require(_id > 0 && _id <= imageCount);
    // Fetch the Image from storage
    Image memory _image = images[_id];

    address payable _author = _image.author;

    address(_author).transfer(msg.value);

    _image.tipAmount += msg.value;

    images[_id] = _image;

    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);

  }
}