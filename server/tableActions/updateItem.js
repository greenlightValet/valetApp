// pass in value to UPDATE

import { updateItem } from './config/updateItem_config.js';

const params = {
  TableName: 'receipts',
  Key: {
    receiptID: '009b0576-f9f7-41a4-a257-9dac699ce64a',
  },
  ExpressionAttributeNames: {
    '#f': 'likesFootball',
  },
  UpdateExpression: 'set #a = :a, #f = :f',
  ExpressionAttributeValues: {
    ':a': 34,
    ':f': true,
  },
};
updateItem(params);
