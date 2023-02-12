import { DeleteCommand } from '@aws-sdk/lib-dynamodb';
import { ddbDocClient } from '../libs/ddbDocClient.js';

// Set the parameters.
export const params = {
  TableName: 'Clients',
  Key: {
    Name: 'DEF',
    Code: 2,
  },
};

export const deleteItem = async () => {
  try {
    await ddbDocClient.send(new DeleteCommand(params));
    console.log('Success - item deleted');
  } catch (err) {
    console.log('Error', err);
  }
};
deleteItem();
