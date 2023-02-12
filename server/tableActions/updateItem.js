import { UpdateCommand } from '@aws-sdk/lib-dynamodb';
import { ddbDocClient } from '../libs/ddbDocClient.js';

export const updateItem = async () => {
  // Set the parameters.
  const params = {
    TableName: 'receipts',
    Key: {
      receiptID: '1591234f-6a8f-403a-b305-12988df00ef8',
      clientName: 'John Jack',
    },
  };
  try {
    const data = await ddbDocClient.send(new UpdateCommand(params));
    console.log('Success - item added or updated', data);
    return data;
  } catch (err) {
    console.log('Error', err);
  }
};
updateItem();
