const path = require("path");
const solc = require("solc");
const fs = require("fs-extra");

const mainFileName = 'Campaign.sol';

const buildPath = path.resolve(__dirname, "build");
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname, "contracts", "Campaign.sol");
const source = fs.readFileSync(campaignPath, "utf8");

const config = {
  language: 'Solidity',
  sources: {
    [mainFileName]: {
      content: source
    },
  },
  settings: {
    outputSelection: {
      '*': {
        '*': ['*']
      }
    }
  }
};

const output = JSON.parse(solc.compile(JSON.stringify(config))).contracts[mainFileName];

fs.ensureDirSync(buildPath);

for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract + ".json"),
    output[contract]
  );
}
