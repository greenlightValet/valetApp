// Import required AWS SDK clients and commands for Node.js
import { DeleteTableCommand } from '@aws-sdk/client-dynamodb';
import { ddbClient } from '../libs/ddbClient.js';

// Set the parameters
export const params = {
  TableName: 'tempRecieptDB',
};

export const run = async () => {
  try {
    const data = await ddbClient.send(new DeleteTableCommand(params));
    console.log('Success, table deleted', data);
    return data;
  } catch (err) {
    console.log('Error', err);
  }
};
run();
