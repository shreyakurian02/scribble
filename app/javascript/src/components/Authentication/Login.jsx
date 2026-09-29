import React from "react";

import { Button, Typography } from "neetoui";
import { Form, Input } from "neetoui/formik";
import { useTranslation } from "react-i18next";
import { Link } from "react-router-dom";

import { setAuthHeaders } from "apis/axios";
import { ARTICLES_URL, SIGNUP_URL } from "constants/urls";
import { useLogin } from "hooks/reactQuery/useAuthApi";
import { storeUser } from "utils/storage";

import { LOGIN_INITIAL_VALUES, LOGIN_VALIDATION_SCHEMA } from "./constants";

const Login = () => {
  const { t } = useTranslation();

  const onSuccess = ({ data }) => {
    storeUser(data);
    setAuthHeaders();
    window.location.href = ARTICLES_URL;
  };

  const { mutate: login } = useLogin({ onSuccess });

  const handleSubmit = (values, { setSubmitting }) =>
    login(values, { onSettled: () => setSubmitting(false) });

  return (
    <div className="flex h-screen flex-col items-center justify-center">
      <div className="w-1/3">
        <Typography style="h2">{t("headers.signIn")}</Typography>
        <Form
          formikProps={{
            initialValues: LOGIN_INITIAL_VALUES,
            validationSchema: LOGIN_VALIDATION_SCHEMA,
            onSubmit: handleSubmit,
          }}
        >
          {({ isSubmitting }) => (
            <div className="mt-3 space-y-5">
              <Input
                required
                label={t("input.email")}
                name="email"
                type="email"
              />
              <Input
                required
                label={t("input.password")}
                name="password"
                type="password"
              />
              <Button
                fullWidth
                disabled={isSubmitting}
                label={t("button.signIn")}
                loading={isSubmitting}
                type="submit"
              />
              <Typography className="text-center" style="body2">
                <Link to={SIGNUP_URL}>{t("button.signUp")}</Link>
              </Typography>
            </div>
          )}
        </Form>
      </div>
    </div>
  );
};

export default Login;
