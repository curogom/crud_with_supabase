// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { createClient, SupabaseClient } from 'jsr:@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE',
}

interface BoardDetail {
  name: string
  content: string
  writerId: string
}

async function getBoard(supabaseClient: SupabaseClient, id: string) {
  const { data: board, error } = await supabaseClient.from('boards').select('*').eq('id', id)
  if (error) throw error

  return new Response(JSON.stringify({ board }), {
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    status: 200,
  })
}

async function getAllBoards(supabaseClient: SupabaseClient) {
  const { data: boards, error } = await supabaseClient.from('boards').select('*')
  if (error) throw error

  return new Response(JSON.stringify({ boards }), {
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    status: 200,
  })
}

async function deleteBoard(supabaseClient: SupabaseClient, id: string) {
  const { error } = await supabaseClient.from('boards').delete().eq('id', id)
  if (error) throw error

  return new Response(JSON.stringify({}), {
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    status: 200,
  })
}

async function updateBoard(supabaseClient: SupabaseClient, id: string, board: BoardDetail, writerId: string) {
  const { error } = await supabaseClient.from('boards').update(board).eq('id', id).eq('writerId', writerId)
  if (error) throw error

  return new Response(JSON.stringify({ task }), {
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    status: 200,
  })
}

async function createBoard(supabaseClient: SupabaseClient, board: BoardDetail) {
  const { error } = await supabaseClient.from('boards').insert(board)
  if (error) throw error

  return new Response(JSON.stringify({ board }), {
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    status: 200,
  })
}

Deno.serve(async (req) => {
  const { url, method } = req

  // This is needed if you're planning to invoke your function from a browser.
  if (method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Create a Supabase client with the Auth context of the logged in user.
    const supabaseClient = createClient(
      // Supabase API URL - env var exported by default.
      Deno.env.get('SUPABASE_URL') ?? '',
      // Supabase API ANON KEY - env var exported by default.
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      // Create client with Auth context of the user that called the function.
      // This way your row-level-security (RLS) policies are applied.
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    )

    // For more details on URLPattern, check https://developer.mozilla.org/en-US/docs/Web/API/URL_Pattern_API
    const u = new URL(url);
    const id = u.searchParams.get('id') ?? null

    let board = null
    if (method === 'POST' || method === 'PUT') {
      const body = await req.json()
      board = body.board
    }

    // call relevant method based on method and id
    switch (true) {
      case id && method === 'GET':
        return getBoard(supabaseClient, id as string)
      case id && method === 'PUT':
        return updateBoard(supabaseClient, id as string, board)
      case id && method === 'DELETE':
        return deleteBoard(supabaseClient, id as string)
      case method === 'POST':
        return createBoard(supabaseClient, board)
      case method === 'GET':
      default:
        return getAllBoards(supabaseClient)
    }
  } catch (error) {
    console.error(error)

    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})