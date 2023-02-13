// pass in values to GET

import { getItem } from './config/getItem_config.js';

// Set the parameters.
export const params = {
  TableName: 'receipts',
  Key: {
    receiptID: '8cbc831b-d28c-4609-869a-0a371fede2cc',
  },
};

getItem(params);
