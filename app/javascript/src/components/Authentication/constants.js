import { t } from "i18next";
import * as yup from "yup";

const required = key => t("validations.required", { entity: t(key) });

export const LOGIN_INITIAL_VALUES = { email: "", password: "" };

export const LOGIN_VALIDATION_SCHEMA = yup.object().shape({
  email: yup
    .string()
    .email(t("validations.invalidEmail"))
    .required(required("input.email")),
  password: yup.string().required(required("input.password")),
});

export const SIGNUP_INITIAL_VALUES = {
  firstName: "",
  lastName: "",
  email: "",
  password: "",
  passwordConfirmation: "",
};

export const SIGNUP_VALIDATION_SCHEMA = yup.object().shape({
  firstName: yup.string().required(required("input.firstName")),
  lastName: yup.string(),
  email: yup
    .string()
    .email(t("validations.invalidEmail"))
    .required(required("input.email")),
  password: yup
    .string()
    .min(6, t("validations.minimumPasswordLength"))
    .required(required("input.password")),
  passwordConfirmation: yup
    .string()
    .oneOf([yup.ref("password")], t("validations.passwordMatch"))
    .required(required("input.passwordConfirmation")),
});
