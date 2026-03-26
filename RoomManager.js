// RoomManager.js - Handles room creation, code generation, and persistence

pragma Singleton
import QtQuick

QtObject {
    id: roomManager
    
    // Generate a random room code (alphanumeric, 8 characters)
    function generateCode() {
        const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let code = ""
        for (let i = 0; i < 8; i++) {
            code += chars.charAt(Math.floor(Math.random() * chars.length))
        }
        return code
    }
    
    // Create a new room
    function createRoom(name, isPublic) {
        const room = {
            id: Date.now(),
            name: name,
            type: isPublic ? "public" : "private",
            code: generateCode(),
            createdAt: new Date().toISOString(),
            members: 1,
            messages: []
        }
        return room
    }
    
    // Find room by code
    function findRoomByCode(rooms, code) {
        for (let i = 0; i < rooms.length; i++) {
            if (rooms[i].code === code.toUpperCase()) {
                return { room: rooms[i], index: i }
            }
        }
        return null
    }
    
    // Add member to room
    function addMemberToRoom(room, memberName) {
        if (!room.members) {
            room.members = 0
        }
        room.members++
        return room
    }
    
    // Save rooms to JSON file using FileIO
    function saveRoomsToFile(rooms, filePath) {
        // For now, we'll return the JSON string
        // In production, use a C++ file I/O backend
        return JSON.stringify(rooms, null, 2)
    }
    
    // Load rooms from JSON file
    function loadRoomsFromFile(jsonString) {
        try {
            return JSON.parse(jsonString)
        } catch(e) {
            console.log("Error parsing rooms JSON:", e)
            return []
        }
    }
}
