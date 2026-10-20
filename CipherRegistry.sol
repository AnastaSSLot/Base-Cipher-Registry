// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract CipherRegistry {
    struct Entry {
        bytes32 dataHash;
        string tag;
        uint256 recordedAt;
        bool isArchived;
    }

    address public immutable keeper;
    string public registryTitle;
    uint256 public totalRecords;

    mapping(uint256 => Entry) public entries;

    event RecordAdded(uint256 indexed recordId, bytes32 indexed dataHash, string tag);
    event TagUpdated(uint256 indexed recordId, string newTag);
    event ArchiveStatusChanged(uint256 indexed recordId, bool isArchived);
    event TitleChanged(string newTitle);

    modifier onlyKeeper() {
        require(msg.sender == keeper, "CipherRegistry: Access denied");
        _;
    }

    constructor() {
        keeper = msg.sender;
        registryTitle = "Cipher Protocol Base Audit Log";
    }

    // 1. Записать новый хэш и категорию
    function recordEntry(bytes32 dataHash, string calldata tag) external onlyKeeper returns (uint256) {
        require(dataHash != bytes32(0), "CipherRegistry: Zero hash forbidden");

        totalRecords++;
        entries[totalRecords] = Entry({
            dataHash: dataHash,
            tag: tag,
            recordedAt: block.timestamp,
            isArchived: false
        });

        emit RecordAdded(totalRecords, dataHash, tag);
        return totalRecords;
    }

    // 2. Сменить категорию / тег
    function updateTag(uint256 recordId, string calldata newTag) external onlyKeeper {
        require(recordId > 0 && recordId <= totalRecords, "CipherRegistry: Non-existent ID");
        entries[recordId].tag = newTag;
        emit TagUpdated(recordId, newTag);
    }

    // 3. Переключить статус архивации
    function toggleArchived(uint256 recordId) external onlyKeeper {
        require(recordId > 0 && recordId <= totalRecords, "CipherRegistry: Non-existent ID");
        entries[recordId].isArchived = !entries[recordId].isArchived;
        emit ArchiveStatusChanged(recordId, entries[recordId].isArchived);
    }

    // 4. Обновить общее название реестра
    function updateRegistryTitle(string calldata newTitle) external onlyKeeper {
        require(bytes(newTitle).length > 0, "CipherRegistry: Empty title");
        registryTitle = newTitle;
        emit TitleChanged(newTitle);
    }

    // Чтение записи
    function getEntry(uint256 recordId) external view returns (
        bytes32 dataHash,
        string memory tag,
        uint256 recordedAt,
        bool isArchived
    ) {
        Entry memory item = entries[recordId];
        return (item.dataHash, item.tag, item.recordedAt, item.isArchived);
    }
}