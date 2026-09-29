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

export { setToLocalStorage, getFromLocalStorage, getVisitorToken };
