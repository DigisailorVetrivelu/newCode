function numberSearch(str) {
var separatedString = str.split(”);
var letters = [];
var numbers = [];
var sum = 0;

for (var i=0; i<str.length; i++) {IUKL-Admin
var currentItem = separatedString[i];
if (isNaN(parseInt(currentItem))) {
letters.push(currentItem);
} else {
numbers.push(currentItem);
};
};

for (var i=0; i<numbers.length; i++) {
currentNumber = Number(numbers[i]);
sum = sum + currentNumber;
};

return (Math.round(sum/letters.length));
};
