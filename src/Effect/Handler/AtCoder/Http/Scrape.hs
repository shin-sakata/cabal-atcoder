module Effect.Handler.AtCoder.Http.Scrape where

import Data.Maybe (isJust)
import Essential
import Text.HTML.Scalpel
  ( AttributeName (..),
    AttributePredicate,
    Selector,
    TagName (..),
    URL,
    (@:),
    (@=),
  )
import qualified Text.HTML.Scalpel as Scalpel

newtype Html = Html Text

-- htmlのテキストからcsrf_tokenを取得する処理
extractCsrfToken :: MonadThrow m => Html -> m Text
extractCsrfToken (Html html) =
  maybeToMonadThrow
    (NotFound "csrf_token")
    (Scalpel.scrapeStringLike html $ Scalpel.attr "value" selector)
  where
    selector :: Selector
    selector =
      tag @: predicates

    tag :: TagName
    tag =
      TagString "input"

    predicates :: [AttributePredicate]
    predicates =
      [AttributeString "name" @= "csrf_token"]

hasSuccess :: Html -> Bool
hasSuccess (Html html) =
  isJust $ Scalpel.scrapeStringLike html $ Scalpel.html selector
  where
    selector :: Selector
    selector =
      tag @: predicates

    tag :: TagName
    tag =
      TagString "div"

    predicates :: [AttributePredicate]
    predicates =
      [Scalpel.hasClass "alert-success"]

-- atcoder.jp/contest/{contestId}/tasksからTasksを抽出する
-- <td class="text-center no-break"><a href="/contests/abc174/tasks/abc174_a">A</a></td>
extractTasks :: MonadThrow m => Html -> m [Text]
extractTasks (Html html) =
  maybeToMonadThrow
    (NotFound "tasks")
    (Scalpel.scrapeStringLike html $ Scalpel.texts selector)
  where
    selector :: Selector
    selector =
      tag @: predicates

    tag :: TagName
    tag =
      TagString "td"

    predicates :: [AttributePredicate]
    predicates =
      [Scalpel.hasClass "text-center", Scalpel.hasClass "no-break"]

-- Exception
data ScrapeException
  = NotFound Text

instance Show ScrapeException where
  show (NotFound target) = convertString target <> " is not found."

instance Exception ScrapeException
