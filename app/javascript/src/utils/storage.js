const setToLocalStorage = ({ key, value }) =>
  localStorage.setItem(key, JSON.stringify(value));

const getFromLocalStorage = key => {
  let response = "";
  try {
    const value = localStorage.getItem(key);
    response = value ? JSON.parse(value) : "";
  } catch (error) {
    logger.error(error);
    response = "";
  }

  return response;
};

const VISITOR_TOKEN_KEY = "visitorToken";
let inMemoryVisitorToken = null;

const getVisitorToken = () => {
  const stored = getFromLocalStorage(VISITOR_TOKEN_KEY);
  if (stored) return stored;

  const token = inMemoryVisitorToken || crypto.randomUUID();
  inMemoryVisitorToken = token;
  try {
    setToLocalStorage({ key: VISITOR_TOKEN_KEY, value: token });
  } catch (error) {
    // Storage is unavailable (e.g. private mode); keep the token in memory.
    logger.error(error);
  }

  return token;
};

const USER_TOKEN_KEY = "userToken";
const USER_STORAGE_KEYS = [
  USER_TOKEN_KEY,
  "authUserId",
  "authUserEmail",
  "authUserName",
];

const getUserToken = () => getFromLocalStorage(USER_TOKEN_KEY);

const storeUser = ({ user, authentication_token: token }) => {
  setToLocalStorage({ key: USER_TOKEN_KEY, value: token });
  setToLocalStorage({ key: "authUserId", value: user.id });
  setToLocalStorage({ key: "authUserEmail", value: user.email });
  setToLocalStorage({
    key: "authUserName",
    value: [user.first_name, user.last_name].filter(Boolean).join(" "),
  });
};

const clearUser = () =>
  USER_STORAGE_KEYS.forEach(key => localStorage.removeItem(key));

export {
  setToLocalStorage,
  getFromLocalStorage,
  getVisitorToken,
  getUserToken,
  storeUser,
  clearUser,
};
