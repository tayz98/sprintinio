/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {CLIENT_ID, CLIENT_SECRET} from "./secrets";
import {setGlobalOptions} from "firebase-functions/v2";

import axios from "axios";
setGlobalOptions({region: "europe-west3"});


export const getAccessToken = onCall(async (req: any) => {
  const authorizationCode = req.data.code;
  if (!authorizationCode) {
    return {error: "Missing authorization code"};
  }

  try {
    const response = await axios.post("https://api.clickup.com/api/v2/oauth/token", null, {
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      params: {
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        code: authorizationCode,
      },
    });

    if (response.status === 200) {
      logger.info("Access token fetched successfully");
      return response.data;
    } else {
      logger.error(`Failed to fetch access token: ${response.statusText}`);
      return {error: response.statusText};
    }
  } catch (error) {
    logger.error("Error fetching access token:", error);
    return {error: "Internal Server Error"};
  }
});

export const getTaskById = onCall(async (req: any) => {
  const accessToken = req.data.accessToken;
  const taskId = req.data.id;
  if (!accessToken) {
    return {error: "Missing access token"};
  }
  if (!taskId) {
    return {error: "Missing task id"};
  }

  try {
    const response = await axios.get(`https://api.clickup.com/api/v2/task/${taskId}`, {
      headers: {
        Authorization: accessToken,
      },
    });

    if (response.status === 200) {
      logger.info("Task fetched successfully");
      return response.data;
    } else {
      logger.error(`Failed to fetch task: ${response.statusText}`);
      return {error: response.statusText};
    }
  } catch (error) {
    logger.error("Error fetching task:", error);
    return {error: "Internal Server Error"};
  }
});

export const getTasksFromList = onCall(async (req: any) => {
  const accessToken = req.data.accessToken;
  const listId = req.data.id;
  if (!accessToken) {
    return {error: "Missing access token"};
  }
  if (!listId) {
    return {error: "Missing list id"};
  }

  try {
    const response = await axios.get(`https://api.clickup.com/api/v2/list/${listId}/task`, {
      headers: {
        Authorization: accessToken,
      },
    });

    if (response.status === 200) {
      logger.info("Tasks fetched successfully");
      return response.data;
    } else {
      logger.error(`Failed to fetch tasks: ${response.statusText}`);
      return {error: response.statusText};
    }
  } catch (error) {
    logger.error("Error fetching tasks:", error);
    return {error: "Internal Server Error"};
  }
});

