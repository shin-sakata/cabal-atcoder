module Effect.Handler.AtCoder.Http where

import Control.Monad.State (get)
import qualified Data.Text as T
import Domain.Object.Contest (Contest (..))
import Domain.Object.ContestId (ContestId (..))
import Domain.Object.TaskId (TaskId (..))
import qualified Domain.Object.TaskId as TaskId
import Domain.Object.UserName (UserName (UserName))
import Domain.Object.UserPassword (UserPassword (UserPassword))
import Effect.Adapter.AtCoder (AtCoder (..))
import qualified Effect.Adapter.AtCoder as AtCoder
import qualified Effect.Adapter.IO as IO
import Effect.Adapter.SessionRepository (Session)
import Effect.Handler.AtCoder.Http.Client
  ( GET (GET),
    NoReqBody (..),
    POST (POST),
    ReqBodyUrlEnc (..),
    Scheme (Https),
    Url,
    bsResponse,
    https,
    runSession,
    (/:),
    (=:),
  )
import qualified Effect.Handler.AtCoder.Http.Client as HttpClient
import Effect.Handler.AtCoder.Http.Scrape (Html (Html))
import qualified Effect.Handler.AtCoder.Http.Scrape as Scrape
import Essential

run ::
  forall effs a.
  IO.HasEff effs =>
  Session ->
  Eff (AtCoder.NamedEff ': effs) a ->
  Eff effs a
run initSession effs = peelEff0 pure interpret effs
  where
    interpret :: forall r. AtCoder.AnonEff r -> (r -> Eff effs a) -> Eff effs a
    interpret (CreateSession userName userPassword) k = do
      session <- IO.lift $ retractEff $ flip evalStateDef initSession $ createSession userName userPassword
      k session
    interpret (GetContest contestId) k = do
      contest <- IO.lift $ retractEff $ flip evalStateDef initSession $ getContest contestId
      k contest

-- AtCoder endpoint
endpoint :: Url 'Https
endpoint = https "atcoder.jp"

createSession :: UserName -> UserPassword -> Eff [StateDef Session, IO.NamedEff] Session
createSession (UserName userName) (UserPassword userPassword) = do
  let loginEndpoint = endpoint /: "login"

  r <-
    HttpClient.reqWithSession
      GET
      loginEndpoint
      NoReqBody
      bsResponse
      mempty

  let loginPageHtml = Html $ convertString $ HttpClient.responseBody $ r

  csrfToken <- liftIO $ Scrape.extractCsrfToken loginPageHtml

  let body =
        ReqBodyUrlEnc $
          ("username" =: userName) <> ("password" =: userPassword) <> ("csrf_token" =: csrfToken)
  r <-
    HttpClient.reqWithSession
      POST
      loginEndpoint
      body
      bsResponse
      mempty

  if Scrape.hasSuccess $ Html $ convertString $ HttpClient.responseBody r
    then get
    else liftIO $ throwM $ AtCoderException "Username or Password is incorrect."

getContest :: ContestId -> Eff [StateDef Session, IO.NamedEff] Contest
getContest (ContestId contestId) = do
  let tasksEndpoint = endpoint /: "contests" /: contestId /: "tasks"

  r <-
    HttpClient.reqWithSession
      GET
      tasksEndpoint
      NoReqBody
      bsResponse
      mempty

  -- 404だった場合は入力が違うためエラー
  when
    (HttpClient.responseStatusCode r == 404)
    (throwM $ AtCoderException [st|Contest not found. Contest id: #{contestId}|])

  let tasksDocument = Html $ convertString $ HttpClient.responseBody r

  tasks <- map TaskId.fromText <$> Scrape.extractTasks tasksDocument

  let contest =
        Contest
          { id = (ContestId contestId),
            tasks = tasks
          }

  pure contest

-- Exception
data AtCoderException
  = AtCoderException Text

instance Show AtCoderException where
  show (AtCoderException msg) = convertString msg

instance Exception AtCoderException
