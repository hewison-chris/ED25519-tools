module hex;

import std.conv;
import std.algorithm;
import std.format;
import std.array : array;
import std.range : chunks;

/// Read a hex string into ubyte[]
ubyte[] readHex(string hexString) @safe
{
    ubyte[] res = (hexString.length % 2 ? "0" ~ hexString : hexString).chunks(2)
        .map!(twoDigits => twoDigits.parse!ubyte(16)).array();
    return res.dup;
}

///
unittest
{
    assert(readHex("012A") == [0x01, 0x2A]);
}

/// Write hex string from ubyte array
string writeHex(const ubyte[] bytes) @safe
{
    return format("%(%02X%)", bytes);
}

///
unittest
{
    assert(writeHex([1, 16]) == "0110");
}

/// Write hex string from ubyte array
string hexToText(const ubyte[] bytes) @safe
{
    return to!string(bytes.map!(to!char));
}

///
unittest
{
    assert(hexToText(readHex("49206C6F766520424F5341474F5241")) == "I love BOSAGORA");
}

/// Write utf-8 string to hex
ubyte[] textToBuf(const string txt) @safe
{
    return txt.map!(to!ubyte).array;
}

///
unittest
{
    assert(textToBuf("I ") == [0x49, 0x20]);
}
