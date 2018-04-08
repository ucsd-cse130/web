--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend)
import Data.List
import Hakyll
import Text.Pandoc
import Text.Pandoc.Walk (walk)

-- | For conditional inclusion: the key you want to keep in the resulting html;
--   all other keys will be removed
mode = "lecture"
-- mode = "final"

crunchWithCtx ctx = do
  route   $ setExtension "html"
  compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html"    ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

crunchWithCtxOpt ctx opt = do
  route   $ setExtension "html"
  compile $ pandocCompilerWithTransform
              defaultHakyllReaderOptions
              defaultHakyllWriterOptions
              (walk (toggleMode . haskellizeBlock) . walk haskellizeInline)
            >>= loadAndApplyTemplate "templates/page.html"    ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

-- | Treat an ordered list with uppercase roman numerals as a map:
--   in each item, the first paragraph is the key, and the second is the value;
--   pick the value with key `mode` and discard all other items
toggleMode :: Block -> Block
toggleMode (OrderedList (_, UpperRoman, _) items) = select items
  where
    select ([Para [Str key], payload] : rest) =
      if key == mode then payload else select rest
    select _ = Null
toggleMode b = b

-- | Make inline code Haskell by default
haskellizeInline :: Inline -> Inline
haskellizeInline (Code (ident, [], kvs) str) = Code (ident, ["haskell"], kvs) str
haskellizeInline i = i

-- | Make code blocks Haskell by default
haskellizeBlock :: Block -> Block
haskellizeBlock (CodeBlock (ident, [], kvs) str) = CodeBlock (ident, ["haskell"], kvs) str
haskellizeBlock b = b

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
  match "static/*/*"    $ do route idRoute
                             compile copyFileCompiler
  match (fromList tops) $ crunchWithCtx siteCtx
  match "lectures/*"    $ crunchWithCtxOpt postCtx mode
  match "assignments/*" $ crunchWithCtx postCtx
  match "templates/*"   $ compile templateCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField  "date"       "%B %e, %Y"  `mappend`
    -- constField "headerImg"  "Eiffel.jpg" `mappend`
    siteCtx

siteCtx :: Context String
siteCtx =
    --   constField "baseUrl" "file:///Users/rjhala/teaching/130-web/_site/" `mappend`
    constField "baseUrl"            "https://ucsd-cse130.github.io/web"     `mappend`
    constField "site_name"          "cse130"                    `mappend`
    constField "site_description"   "UCSD CSE 130"              `mappend`
    -- constField "instagram_username" "ranjitjhala"               `mappend`
    constField "site_username"      "Ranjit Jhala"              `mappend`
    constField "twitter_username"   "ranjitjhala"               `mappend`
    constField "github_username"    "ucsd-progsys/130-web"      `mappend`
    constField "google_username"    "rjhala@eng.ucsd.edu"       `mappend`
    constField "google_userid"      "u/0/106612421534244742464" `mappend`
    constField "piazza_classid"     "ucsd/spring2017/cse130/home" `mappend`
    defaultContext


tops =
  [ "index.md"
  , "grades.md"
  , "lectures.md"
  , "links.md"
  , "assignments.md"
  , "calendar.md"
  , "contact.md"
  ]
