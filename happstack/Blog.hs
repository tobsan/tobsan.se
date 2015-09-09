--
-- Copyright (c) 2015 Tobias Olausson
--
-- This code is licensed under the MIT license.
-- See the LICENSE file or http://opensource.org/licenses/MIT
--

-- Blog module

module Blog where

import Control.Concurrent
import Control.Monad
import Control.Monad.Trans
import Happstack.Server 

blog :: ServerPartT IO Response
blog = msum 
    [ nullDir >> mainBlog
    , dir "category" showCategory
    , findArticle
    ]

-- TODO: better parser for string -> int
findArticle :: ServerPartT IO Response
findArticle = path $ \y -> 
    let year = read y :: Int
    in msum [ nullDir >> showYear year
         , path $ \m -> 
            let month = read m :: Int
            in msum [ nullDir >> showMonth year month
                 , path $ \d -> 
                    let day = read d :: Int
                    in showDay year month day
                 ]
         ]

showYear y = ok $ toResponse ("Articles for " ++ show y)
showMonth y m = ok $ toResponse ("Articles for " ++ (show y) ++ ", month " ++ (show m))
showDay y m d = ok $ toResponse ("Articles for " ++ (show y) ++ ", month " ++ (show m) ++ ", day " ++ (show d))

-- TODO
showCategory = msum
    [ nullDir >> categoryList
    ]

-- TODO
categoryList = undefined

mainBlog :: ServerPartT IO Response
mainBlog = ok $ toResponse ("This is the blog" :: String)

