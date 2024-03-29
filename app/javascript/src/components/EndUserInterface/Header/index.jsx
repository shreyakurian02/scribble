import React, { useState, useEffect, useRef } from "react";

import { Search } from "neetoicons";
import { Typography, Input } from "neetoui";
import { useTranslation } from "react-i18next";

import useDebounce from "hooks/useDebounce";

import FilteredArticles from "./FilteredArticles";

const Header = ({ siteTitle }) => {
  const { t } = useTranslation();

  const [searchTerm, setSearchTerm] = useState("");

  const inputRef = useRef(null);
  const debouncedSearchTerm = useDebounce(searchTerm);

  const handleKeyDown = event => {
    if (event.key === "/") {
      event.preventDefault();
      inputRef.current.focus();
    }
  };

  useEffect(() => {
    document.addEventListener("keydown", handleKeyDown);

    return () => {
      document.removeEventListener("keydown", handleKeyDown);
    };
  }, []);

  return (
    <div className="border-b sticky z-10 flex h-16 w-full items-center justify-center px-6 py-4">
      <div className="absolute right-0 top-0 w-1/4 px-2 py-4">
        <Input
          placeholder={t("placeholder.euiSearchArticles")}
          prefix={<Search />}
          ref={inputRef}
          type="search"
          value={searchTerm}
          onChange={({ target: { value } }) => setSearchTerm(value)}
        />
        <FilteredArticles
          debouncedSearchTerm={debouncedSearchTerm}
          searchTerm={searchTerm}
          setSearchTerm={setSearchTerm}
        />
      </div>
      <Typography className="neeto-ui-text-gray-800" style="h4">
        {siteTitle}
      </Typography>
    </div>
  );
};

export default Header;
