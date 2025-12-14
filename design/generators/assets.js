const fs = require("fs");

const map = {};

const ops = [
  {
    path: "game/assets/image/avatar",
    key: "avatars",
  },
  {
    path: "game/assets/image/background",
    key: "backgrounds",
  },
];

for (const op of ops) {
  const path = op.path;
  map[op.key] = {};
  const files = fs.readdirSync(path);
  for (const file of files) {
    const key = file.toUpperCase().split(".")[0];
    const value = path + "/" + file;
    map[op.key][key] = value;
  }
}

fs.writeFileSync("design/generators/images.json", JSON.stringify(map));
