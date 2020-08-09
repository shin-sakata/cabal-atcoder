module InterfaceAdapter.Impl.AtCoder.Http where

import Data.Extensible.Effect (Eff, leaveEff, peelEff0, retractEff)
import Data.Extensible (type (>:))
import Data.Extensible.Effect.Default
import DomainObject.UserName (UserName (UserName))
import DomainObject.UserPassword (UserPassword (UserPassword))
import Essential hiding (lift)
import InterfaceAdapter.Class.AtCoder (AtCoder (..))
import qualified InterfaceAdapter.Class.AtCoder as AtCoder
import qualified InterfaceAdapter.Class.IO as IO
import InterfaceAdapter.Class.SessionRepository (Session)
import InterfaceAdapter.Impl.AtCoder.Http.Client
  ( GET (GET),
    HttpClient,
    NoReqBody (..),
    POST (POST),
    ReqBodyUrlEnc (..),
    Scheme (Https),
    Url,
    bsResponse,
    https,
    (/:),
    (=:),
  )
import qualified InterfaceAdapter.Impl.AtCoder.Http.Client as HttpClient
import InterfaceAdapter.Impl.AtCoder.Http.Scrape (Html (Html))
import qualified InterfaceAdapter.Impl.AtCoder.Http.Scrape as Scrape
import RIO.State (get, put)
import qualified RIO.Text as T

run ::
  forall effs a.
  (IO.HasEff effs) =>
  Session ->
  Eff (AtCoder.NamedEff ': effs) a ->
  Eff effs a
run initSession effs = peelEff0 pure interpret effs
  where
    interpret :: forall r. AtCoder.AnonEff r -> (r -> Eff effs a) -> Eff effs a
    interpret (CreateSession userName userPassword) k = do
      session <- IO.lift $ retractEff $ HttpClient.runSession initSession $ createSession userName userPassword
      k session

-- AtCoder endpoint
endpoint :: Url 'Https
endpoint = https "atcoder.jp"

createSession :: UserName -> UserPassword -> HttpClient Session
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
    else liftIO $ throw $ AtCoderException "Username or Password is incorrect."

-- Exception
data AtCoderException
  = AtCoderException Text

instance Show AtCoderException where
  show (AtCoderException msg) = convertString msg

instance Exception AtCoderException
