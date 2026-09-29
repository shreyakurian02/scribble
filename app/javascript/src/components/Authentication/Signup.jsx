import React from "react";

import { Button, Typography } from "neetoui";
import { Form, Input } from "neetoui/formik";
import { useTranslation } from "react-i18next";
import { Link } from "react-router-dom";

import { setAuthHeaders } from "apis/axios";
import { ARTICLES_URL, LOGIN_URL } from "constants/urls";
import { useSignup } from "hooks/reactQuery/useAuthApi";
import { storeUser } from "utils/storage";

import { SIGNUP_INITIAL_VALUES, SIGNUP_VALIDATION_SCHEMA } from "./constants";

const Signup = () => {
  const { t } = useTranslation();

  const onSuccess = ({ data }) => {
    storeUser(data);
    setAuthHeaders();
    window.location.href = ARTICLES_URL;
  };

  const { mutate: signup } = useSignup({ onSuccess });

  const handleSubmit = (
    { firstName, lastName, email, password, passwordConfirmation },
    { setSubmitting }
  ) =>
    signup(
      {
        first_name: firstName,
        last_name: lastName,
        email,
        password,
        password_confirmation: passwordConfirmation,
      },
      { onSettled: () => setSubmitting(false) }
    );

  return (
    <div className="flex h-screen flex-col items-center justify-center">
      <div className="w-1/3">
        <Typography style="h2">{t("headers.signUp")}</Typography>
        <Form
          formikProps={{
            initialValues: SIGNUP_INITIAL_VALUES,
            validationSchema: SIGNUP_VALIDATION_SCHEMA,
            onSubmit: handleSubmit,
          }}
        >
          {({ isSubmitting }) => (
            <div className="mt-3 space-y-5">
              <Input
                required
                label={t("input.firstName")}
                name="firstName"
                type="text"
              />
              <Input label={t("input.lastName")} name="lastName" type="text" />
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
              <Input
                required
                label={t("input.passwordConfirmation")}
                name="passwordConfirmation"
                type="password"
              />
              <Button
                fullWidth
                disabled={isSubmitting}
                label={t("button.signUp")}
                loading={isSubmitting}
                type="submit"
              />
              <Typography className="text-center" style="body2">
                <Link to={LOGIN_URL}>{t("button.signIn")}</Link>
              </Typography>
            </div>
          )}
        </Form>
      </div>
    </div>
  );
};

export default Signup;
