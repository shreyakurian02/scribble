import React from "react";

import { Sidebar as NeetoUISidebar } from "neetoui/layouts";

import { LOGIN_URL } from "constants/urls";
import { useLogout } from "hooks/reactQuery/useAuthApi";
import { clearUser } from "utils/storage";

import { NAV_LINKS, SIGN_OUT_LINK, getProfileInfo } from "./constants";

const Sidebar = () => {
  const { mutate: logout } = useLogout({
    onSettled: () => {
      clearUser();
      window.location.href = LOGIN_URL;
    },
  });

  return (
    <NeetoUISidebar
      navLinks={[...NAV_LINKS, { ...SIGN_OUT_LINK, onClick: () => logout() }]}
      profileInfo={getProfileInfo()}
    />
  );
};

export default Sidebar;
