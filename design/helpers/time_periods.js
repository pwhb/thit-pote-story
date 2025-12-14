const fs = require("fs");
const entity = "time_periods";
const locations = require(`../${entity}.json`);

const map = {};
const array = [];
function getCode(name) {
  name = name.replace(/ /g, "_");
  //   remove ' and other special characters
  name = name.replace(/\'/g, "");
  name = name.toUpperCase();
  return name;
}
locations.forEach((v) => {
  const code = getCode(v.name);

  map[code] = {
    name: {
      en: v.name,
      my: v.name,
    },
    period: `${v.from} - ${v.to}`,
  };

  array.push({
    code: code,
    ...map[code],
  });
});
fs.writeFileSync(`${entity}.json`, JSON.stringify(map));
fs.writeFileSync(`${entity}_array.json`, JSON.stringify(array));
console.log(map);
