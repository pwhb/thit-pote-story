const fs = require("fs");
const locations = require("../design/02_locations.json");
locations.forEach(v => {
    v.i18n.en = v.name;
})
fs.writeFileSync("json.json", JSON.stringify(locations));
console.log(locations);
