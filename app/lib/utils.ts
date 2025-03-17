import axios from "axios";

export const getUserByIdentityDocNum = async (identityDocNum: string) => {
  const response = await axios(
    `${process.env.SAP_API_URL}/users/${identityDocNum}`,
    {
      headers: {
        app_name: process.env.APP_NAME,
      },
    }
  ).catch(() => null);

  return response;
};
