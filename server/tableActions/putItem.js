import { PutCommand } from '@aws-sdk/lib-dynamodb';
import { ddbDocClient } from '../libs/ddbDocClient.js';
import { v4 as uuidv4 } from 'uuid';
import { uniqueNamesGenerator, names } from 'unique-names-generator';

const config = {
  dictionaries: [names],
};

const characterName = uniqueNamesGenerator(config); // Winona

// random ID generator
let myuuid = uuidv4();

// random name generator

export const putItem = async () => {
  // Set the parameters.
  const params = {
    TableName: 'receipts',
    Item: {
      receiptID: myuuid,
      clientName: characterName,
    },
  };
  try {
    const data = await ddbDocClient.send(new PutCommand(params));
    console.log('Success - item added or updated', data);
  } catch (err) {
    console.log('Error', err.stack);
  }
};
putItem();
