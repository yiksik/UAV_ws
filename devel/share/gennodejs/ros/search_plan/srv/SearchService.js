// Auto-generated. Do not edit!

// (in-package search_plan.srv)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------


//-----------------------------------------------------------

class SearchServiceRequest {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.req_type = null;
    }
    else {
      if (initObj.hasOwnProperty('req_type')) {
        this.req_type = initObj.req_type
      }
      else {
        this.req_type = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type SearchServiceRequest
    // Serialize message field [req_type]
    bufferOffset = _serializer.int8(obj.req_type, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type SearchServiceRequest
    let len;
    let data = new SearchServiceRequest(null);
    // Deserialize message field [req_type]
    data.req_type = _deserializer.int8(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 1;
  }

  static datatype() {
    // Returns string type for a service object
    return 'search_plan/SearchServiceRequest';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '39fbd496731152d567ca38b71257e0aa';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    int8 req_type #0为恢复正常 1为请求悬停或减速
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new SearchServiceRequest(null);
    if (msg.req_type !== undefined) {
      resolved.req_type = msg.req_type;
    }
    else {
      resolved.req_type = 0
    }

    return resolved;
    }
};

class SearchServiceResponse {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.success = null;
    }
    else {
      if (initObj.hasOwnProperty('success')) {
        this.success = initObj.success
      }
      else {
        this.success = false;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type SearchServiceResponse
    // Serialize message field [success]
    bufferOffset = _serializer.bool(obj.success, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type SearchServiceResponse
    let len;
    let data = new SearchServiceResponse(null);
    // Deserialize message field [success]
    data.success = _deserializer.bool(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 1;
  }

  static datatype() {
    // Returns string type for a service object
    return 'search_plan/SearchServiceResponse';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '358e233cde0c8a8bcfea4ce193f8fc15';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    bool success
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new SearchServiceResponse(null);
    if (msg.success !== undefined) {
      resolved.success = msg.success;
    }
    else {
      resolved.success = false
    }

    return resolved;
    }
};

module.exports = {
  Request: SearchServiceRequest,
  Response: SearchServiceResponse,
  md5sum() { return '755dfbc93987f6abb3e7f3251f87b1d6'; },
  datatype() { return 'search_plan/SearchService'; }
};
