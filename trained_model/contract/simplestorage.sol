pragma solidity ^0.4.19;

contract SimpleStorage {

    struct Message {
        string word; // 留言内容
        string from; // 留言者
        string timestamp ; // 留言unix时间戳
    }

    Message[] private wordArr;

    function setWord(string _word, string _name ,string _time) public {

        wordArr.push(Message({
            word: _word,
            from: _name,
            timestamp: _time
        }));
    }

    function getRandomWord(uint _random) public view returns (uint, string, string, string) {
        if(wordArr.length==0){
            return (0, "手机里没有另一半，至少还有Astromind", "AstroMind", "");
        }else{
            Message storage result = wordArr[_random];
            return (wordArr.length, result.word, result.from, result.timestamp);
        }

    }

    function getWord(uint _index) public view returns (uint, string, string, string) {

        Message storage r = wordArr[_index];
        return (wordArr.length, r.word, r.from, r.timestamp);


    }

}
