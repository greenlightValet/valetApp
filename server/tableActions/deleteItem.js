// pass in value to DELETE
import { deleteItem } from './config/deleteItem_config.js';

export const params = {
  TableName: 'receipts',
  Key: {
    receiptID: '778ab2a2-c475-418a-aab1-93f3b85cca0e',
  },
};
deleteItem(params);
