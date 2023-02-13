// GET functionality

import { GetCommand } from '@aws-sdk/lib-dynamodb';
import { ddbDocClient } from '../../libs/ddbDocClient.js';

export const getItem = async (params) => {
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
