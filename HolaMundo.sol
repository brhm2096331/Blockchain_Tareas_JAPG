// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HolaMundo {
    address public owner;
    mapping(address => string) public nombres;

    constructor() {
        owner = msg.sender;
    }

    modifier soloOwner() {
        require(msg.sender == owner, "Solo el owner puede hacer esto");
        _;
    }

    modifier nombreNoVacio(string memory _nombre) {
        require(bytes(_nombre).length > 0, "El nombre no puede estar vacio");
        _;
    }

    modifier tieneNombre(address _usuario) {
        require(bytes(nombres[_usuario]).length > 0, "Ese usuario no tiene nombre guardado");
        _;
    }

    function guardarNombre(string memory _nombre) public nombreNoVacio(_nombre) {
        nombres[msg.sender] = _nombre;
    }

    function saludar(address _usuario) public view tieneNombre(_usuario) returns (string memory) {
        return string(abi.encodePacked("Hola, ", nombres[_usuario], "!"));
    }

    function borrarNombre(address _usuario) public soloOwner {
        delete nombres[_usuario];
    }
}