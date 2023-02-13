// pass in value to PUT

import { putItem } from './config/putItem_config.js';
import { v4 as uuidv4 } from 'uuid';
let myuuid = uuidv4();
let today = new Date();

const params = {
  TableName: 'receipts',
  Item: {
    receiptID: '009b0576-f9f7-41a4-a257-9dac699ce64a',
    phoneNum: '4251112225',
    clientName: 'HaashimUpdated',
    carMake: 'Honda',
    carModel: 'Accord',
    carColor: 'red',
    licensePlate: 'zzzzzz',
    dateIssued: `${today}`,
  },
};
putItem(params);
