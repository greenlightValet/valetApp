// pass in value to UPDATE

import { updateItem } from './config/updateItem_config.js';

const params = {
  TableName: 'receipts',
  Key: {
    receiptID: '009b0576-f9f7-41a4-a257-9dac699ce64a',
  },
  ExpressionAttributeNames: {
    '#a': 'age',
    '#cc': 'carColor',
    '#cmk': 'carMake',
    '#cmd': 'carModel',
    '#cn': 'clientName',
    '#di': 'dateIssued',
    '#lp': 'licensePlate',
  },
  UpdateExpression: 'set #a = :a',
  ExpressionAttributeValues: {
    ':a': 34,
  },
};
updateItem(params);
