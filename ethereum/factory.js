import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
  CampaignFactory.abi,
  '0xB07Ff2bB7a4905FCCB65305F8F877fE5F0b44d8b'
);

export default instance;
