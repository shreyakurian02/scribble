import React, { useState, useEffect } from "react";

import { PageLoader } from "neetoui";
import { QueryClientProvider } from "react-query";
import { Route, Switch, BrowserRouter as Router } from "react-router-dom";
import { ToastContainer } from "react-toastify";

import { setAuthHeaders, registerIntercepts } from "apis/axios";
import "common/i18n";
import { initializeLogger } from "common/logger";
import Dashboard from "components/Dashboard";
import EndUserInterface from "components/EndUserInterface";
import { PREVIEW_URL, ADMIN_URL } from "constants/urls";
import queryClient from "utils/queryClient";
import { setToLocalStorage } from "utils/storage";

import { DEFAULT_ERROR_VALUES } from "./constants";

const App = ({ user }) => {
  const [isLoading, setIsLoading] = useState(true);
  const [notFoundError, setNotFoundError] = useState(DEFAULT_ERROR_VALUES);

  const setUserToLocalStorage = () => {
    const { id, email } = user;
    setToLocalStorage({ key: "authUserId", value: id });
    setToLocalStorage({ key: "authUserEmail", value: email });
  };

  useEffect(() => {
    initializeLogger();
    registerIntercepts(setNotFoundError);
    setAuthHeaders(setIsLoading);
    setUserToLocalStorage();
  }, []);

  if (isLoading) {
    return (
      <div className="h-screen w-full">
        <PageLoader />
      </div>
    );
  }

  return (
    <QueryClientProvider client={queryClient}>
      <Router>
        <ToastContainer />
        <Switch>
          <Route
            path={ADMIN_URL}
            render={() => (
              <Dashboard
                notFoundError={notFoundError}
                setNotFoundError={setNotFoundError}
                user={user}
              />
            )}
          />
          <Route
            path={PREVIEW_URL}
            render={() => (
              <EndUserInterface
                notFoundError={notFoundError}
                setNotFoundError={setNotFoundError}
              />
            )}
          />
        </Switch>
      </Router>
    </QueryClientProvider>
  );
};

export default App;
