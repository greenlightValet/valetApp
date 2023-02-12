import { GetCommand } from '@aws-sdk/lib-dynamodb';
import { ddbDocClient } from '../libs/ddbDocClient.js';

let tableName = 'receipts';

// Set the parameters.
export const params = {
  TableName: tableName,
  Key: {
    receiptID: '1591234f-6a8f-403a-b305-12988df00ef8',
  },
};

export const getItem = async () => {
  try {
    const data = await ddbDocClient.send(new GetCommand(params));
    if (data.Item == undefined) {
      console.log("Successful ping, but value doesn't exist");
    } else {
      console.log('Success :', data.Item);
    }
  } catch (err) {
    console.log('Error', err);
  }
};
getItem();
