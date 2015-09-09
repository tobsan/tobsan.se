{-# LANGUAGE OverloadedStrings #-}

--
-- Copyright (c) 2015 Tobias Olausson
--
-- This code is licensed under the MIT license.
-- See the LICENSE file or http://opensource.org/licenses/MIT
--
-- Main module

module Main where

import Control.Monad
import Control.Monad.Trans
import System.Directory

import Happstack.Server 

import qualified Text.Markdown as M
import qualified Data.Text.Lazy as TL

import           Text.Blaze ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html4.Strict.Attributes as A
import Text.Blaze.Html.Renderer.Text

import Blog

main :: IO ()
main = simpleHTTP nullConf $ msum 
    [ nullDir >> blog
    , dir "rss" rss
    , dir "blog" blog
    , pages
    ]

rss :: ServerPartT IO Response
rss = ok $ toResponse ("RSS!" :: String)

-- blog :: ServerPartT IO Response
-- blog = ok $ toResponse ("This is the blog" :: String)

-- Serves a markdown page
pages :: ServerPartT IO Response
pages = path $ \s -> do
    let pageFile = s ++ ".md"
    fileExists <- liftIO $ doesFileExist pageFile
    case fileExists of
        True -> do
            contents <- liftIO $ readFile pageFile
            ok $ toResponse $ serveMarkDown contents s
        False -> notFound $ toResponse ()
  where
    serveMarkDown :: String -> String -> H.Html
    serveMarkDown contents title = appTemplate title $ M.markdown M.def $ TL.pack contents

appTemplate :: String -> H.Html -> H.Html
appTemplate name body =
    H.html $ do
      H.head $ H.title $ H.toHtml name
      H.body $ body
