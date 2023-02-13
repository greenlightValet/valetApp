// DELETE functionality
import { DeleteCommand } from '@aws-sdk/lib-dynamodb';
import { ddbDocClient } from '../../libs/ddbDocClient.js';

export const deleteItem = async (params) => {
  try {
    await ddbDocClient.send(new DeleteCommand(params));
    console.log('Success - item deleted');
  } catch (err) {
    console.log('Error', err);
  }
};
