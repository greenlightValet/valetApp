// UPDATE functionality

import { UpdateCommand } from '@aws-sdk/lib-dynamodb';
import { ddbDocClient } from '../../libs/ddbDocClient.js';

export const updateItem = async (params) => {
  // Set the parameters.

  try {
    const data = await ddbDocClient.send(new UpdateCommand(params));
    console.log('Success - item added or updated', data);
    return data;
  } catch (err) {
    console.log('Error', err);
  }
};
updateItem();
